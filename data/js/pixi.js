import {
	Application,
	Graphics,
	Assets,
	Sprite
} from "pixi.js";

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

/** Assets */
const pixi_assets_load = (a, b, input) => {
	return Assets.load(input)
		.then(a => ({ value: a }));
};
/** end Assets */

/** Sprite */
const pixi_new_sprite = (a, texture) => new Sprite(texture);
/** end Sprite */
