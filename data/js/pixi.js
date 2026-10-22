import { Application, Graphics } from "pixi.js";

/** Application */
const pixi_new_application = () => new Application();

const pixi_init_application = (app, option) => {
	return app.init(option)
		.then(_ => ({ value: undefined }));
};
/** end Application */

/** Graphics */
const pixi_new_graphics = () => {
	return new Graphics();
};
/** end Graphics */
