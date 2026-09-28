import { Application } from "pixi.js";

const pixi_new_application = () => new Application();

const pixi_init_application = (app, win) => {
	return app.init({ resizeTo: win })
		.then(_ => ({ value: undefined }));
};
