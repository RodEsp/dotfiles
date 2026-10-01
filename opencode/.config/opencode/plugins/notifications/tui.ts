import { Plugin } from "@opencode/plugin/tui";
import { execFile } from "node:child_process";
import { basename } from "node:path";
import { promisify } from "node:util";

const run = promisify(execFile);

const quote = (value: string) => value.replaceAll("\\", "\\\\").replaceAll('"', '\\"');

async function notify(title: string, message: string) {
  try {
    await run("terminal-notifier", [
      "-title",
      title,
      "-message",
      message,
      "-sound",
      "Ping",
      "-activate",
      "com.mitchellh.ghostty",
    ]);
  } catch {
    try {
      await run("osascript", [
        "-e",
        `display notification "${quote(message)}" with title "${quote(title)}" sound name "Ping"`,
      ]);
    } catch {}
  }
}

export default Plugin.define({
  id: "rodesp.notifications",
  setup(context) {
    const describe = (sessionID: string | undefined) => {
      const directory = context.location?.directory ?? context.data.location.default()?.directory;
      return {
        title: (sessionID && context.data.session.get(sessionID)?.title) || "OpenCode",
        project: directory ? basename(directory) : "OpenCode",
      };
    };

    const stopDone = context.data.on("session.execution.succeeded", (event) => {
      const { title, project } = describe(event.data.sessionID);
      void notify(title, `Session completed in ${project}!`);
    });

    const stopPermission = context.data.on("permission.asked", (event) => {
      const { title, project } = describe(event.data.sessionID);
      void notify(title, `${project} is requesting permission for something.`);
    });

    return () => {
      stopDone();
      stopPermission();
    };
  },
});
