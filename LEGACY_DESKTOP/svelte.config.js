//import adapter from '@sveltejs/adapter-auto'
import path from 'path'

/** @type {import('@sveltejs/kit').Config} */
const config = {
	kit: {
		//adapter: adapter(),
		alias: {
			$src: path.resolve('./src'),
			$public: path.resolve('./public'),
			$tavy: path.resolve("$src/lib/tavy"),
			$text: path.resolve("$tavy/text"),
			$style: path.resolve("./src/global.postcss"),
			$store: path.resolve("./src/stores.ts"),
		}
	}
};

export default config
