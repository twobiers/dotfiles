import { Plugin } from "@opencode/plugin"

export default Plugin.define({
  id: "env-protection",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", (event) => {
      const input = event.input
      if (event.tool === "read" && input?.filePath?.includes(".env")) {
        throw new Error("Do not read .env files")
      }
    })
  },
})
