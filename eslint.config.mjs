import globals from "globals";
import pluginJs from "@eslint/js";


export default [
  {
    languageOptions: {
      globals: {
        ...globals.node,
        // Define Jest global variables
        describe: "readonly",
        it: "readonly",
        expect: "readonly",
        beforeAll: "readonly",
        afterAll: "readonly",
        jest: "readonly",
      }
    },
    ignores: ["**/node_modules/"],
  },
  pluginJs.configs.recommended
];