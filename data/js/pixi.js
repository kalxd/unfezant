import { Application, Graphics } from "pixi.js";

const pixi_new_application = () => new Application();

const pixi_init_application = (app, win) => {
	return app.init({ resizeTo: win })
		.then(_ => ({ value: undefined }));
};

const pixi_application_add_ticker = (f, app) => {
	app.ticker.add(ticker => f(ticker)());
};

/** graphics */
const pixi_new_graphics = () => new Graphics();
/** end graphics */
