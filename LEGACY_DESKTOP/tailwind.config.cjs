/** @type {import("tailwindcss").Config} */


const colors = require("tailwindcss/colors")




let bright = false




module.exports = {
    mode: 'jit',
    content: ["./src/**/*.{html,js,svelte,ts}"],
    theme: {
        fontFamily: {
            body: ['Lexend'],
        },
        extend: {
            flex: {
                center_col: "flex flex-col justify-center items-center",
                center_row: "flex flex-row justify-center items-center",
            },
            colors: {
                background: colors.neutral["900"],
                onBackground: colors.neutral["100"],
            },
            transitionDuration: {
                DEFAULT: '100ms',
                0: '0s',
                100: '100ms',
                200: '200ms',
                400: '400ms',
                800: '800ms',
                1600: '1600ms',
                3200: '3200ms',
            },
        },
    },
    plugins: [],
    // !!
}
