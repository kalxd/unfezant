use futures::{
	channel::mpsc::{channel, Sender},
	future::ready,
	StreamExt,
};
use gtk::{
	glib::MainContext,
	prelude::{
		ApplicationExt, ApplicationExtManual, BoxExt, ButtonExt, ContainerExt, EntryExt,
		TextBufferExt, WidgetExt,
	},
	Application, ApplicationWindow, Box as GtkBox, Button, Entry, Frame, Orientation,
	ScrolledWindow, TextBuffer, TextView,
};

use std::thread;

use crate::client::SendMessage;

mod client;
mod server;

enum Event {
	SendText(String),
	SendMsg(String),
}

struct Widget {
	text_buf: TextBuffer,
}

fn build_ui(app: &Application, tx: Sender<Event>) -> Widget {
	let window = ApplicationWindow::builder()
		.application(app)
		.default_width(600)
		.default_height(400)
		.build();
	let layout = GtkBox::builder()
		.orientation(Orientation::Vertical)
		.spacing(10)
		.build();

	let view_frame = Frame::builder().label("日志").build();
	let scroll_window = ScrolledWindow::builder().build();
	let text_buf = TextBuffer::builder().build();
	let text_view = TextView::builder()
		.buffer(&text_buf)
		.editable(false)
		.build();
	scroll_window.add(&text_view);
	view_frame.add(&scroll_window);
	layout.pack_start(&view_frame, true, true, 0);

	let send_layout = GtkBox::builder().spacing(10).build();
	let entry = Entry::new();
	send_layout.pack_start(&entry, true, true, 0);
	let btn = Button::builder().label("发送").build();
	send_layout.pack_start(&btn, false, true, 0);
	layout.pack_start(&send_layout, false, true, 0);
	btn.connect_clicked({
		let entry = entry.clone();
		let tx = tx.clone();
		move |_| {
			let text = entry.text().to_string();
			entry.set_text("");
			tx.clone().try_send(Event::SendText(text)).unwrap();
		}
	});
	entry.connect_activate(move |entry| {
		let text = entry.text().to_string();
		entry.set_text("");
		tx.clone().try_send(Event::SendText(text)).unwrap();
	});

	window.add(&layout);
	window.show_all();

	Widget { text_buf }
}

fn main() {
	let app = Application::builder()
		.application_id("person.xgley.unfezant")
		.build();

	app.connect_activate({
		move |app| {
			let (tx, rx) = channel::<Event>(10);
			let (stx, srx) = std::sync::mpsc::channel::<String>();

			let widget = build_ui(app, tx.clone());

			thread::spawn(|| {
				println!("server start");
				server::run_server();
			});

			thread::spawn({
				let mut tx = tx.clone();
				move || {
					println!("client start");
					let (client, mut conn) = client::run_client();

					thread::spawn(move || {
						for msg in conn.iter().filter_map(|x| x.ok()) {
							let payload = format!("{:?}\n", msg);
							tx.try_send(Event::SendMsg(payload)).unwrap();

							if let rumqttc::Event::Incoming(rumqttc::Incoming::Publish(pb)) = msg {
								if let Some(json) =
									serde_json::from_slice::<serde_json::Value>(&pb.payload).ok()
								{
									let msg = "接收到：".to_string() + &json.to_string() + "\n";
									tx.try_send(Event::SendMsg(msg)).unwrap();
								}
							}
						}
					});

					thread::spawn(move || {
						while let Ok(msg) = srx.recv() {
							client.send(msg);
						}
					});
				}
			});

			MainContext::default().spawn_local(async move {
				rx.for_each(|msg| {
					match msg {
						Event::SendMsg(text) => {
							let text_buf = &widget.text_buf;
							let mut end = text_buf.end_iter();
							text_buf.insert(&mut end, &text);
						}
						Event::SendText(text) => stx.send(text).unwrap(),
					};

					ready(())
				})
				.await
			});
		}
	});

	app.run();
}
