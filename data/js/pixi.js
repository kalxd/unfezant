import { Application } from "pixi.js";

const pixi_new_application = () => new Application();

const pixi_init_application = (app, win) => app.init({ resizeTo: win });
