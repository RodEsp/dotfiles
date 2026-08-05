import type { Plugin } from "@opencode-ai/plugin";

export default (async ({ project, client, $, directory, worktree }) => {
	const logFile = `/tmp/opencode-${project.id}.log`;
	async function log(msg) {
		// await $`echo "$(date) - ${msg}" >> ${logFile}`;
	}

	// Clear log on startup
	// await $`echo "" > ${logFile}`;

	const proj = JSON.stringify(project, null, 2);
	const wt = JSON.stringify(worktree, null, 2);

	log(proj);
	log(wt);

	let lastSessionInfo: {
		sessionID: string;
		slug: string;
		title: string;
		directory: string;
	} | null = null;

	return {
		event: async ({ event }) => {
			const projectName =
				project?.worktree?.split("/").pop() ||
				project?.id?.slice(0, 8) ||
				"OpenCode";

			// log(`EVENT: ${event.type}`);

			if (event.type === "session.updated" && event.properties?.info) {
				const info = event.properties.info;
				lastSessionInfo = {
					sessionID: info.id,
					slug: info.slug,
					title: info.title,
					directory: info.directory,
				};
			}
			const title = lastSessionInfo ? lastSessionInfo.title : "Opencode";

			const sendNotification = async (title: string, message: string) => {
				try {
					await $`terminal-notifier -title "${title}" -message "${message}" -sound Ping -activate "com.mitchellh.ghostty" 2>/dev/null`;
					log(`notification SENT (terminal-notifier): ${title}`);
				} catch {
					try {
						await $`osascript -e 'display notification "${message}" with title "${title}" sound name "Ping"'`;
						log(`notification SENT (osascript): ${title}`);
					} catch (e) {
						log(`notification FAILED: ${e}`);
					}
				}
			};

			if (event.type === "session.idle") {
				log(JSON.stringify(event, null, 2));
				await sendNotification(title, `Session completed in ${projectName}!`);
			}
			if (event.type === "permission.asked") {
				log(JSON.stringify(event, null, 2));
				await sendNotification(
					title,
					`${projectName} is requesting permission for something.`,
				);
			}
		},
	};
}) satisfies Plugin;
