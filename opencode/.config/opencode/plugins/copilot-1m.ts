import type { Plugin } from "@opencode-ai/plugin";

const MODEL_VARIANTS = [
  {
    baseID: "claude-opus-4.6",
    variantID: "claude-opus-4.6-1m",
    preserveExisting: false,
    limit: { context: 1000000, input: 900000 },
  },
  {
    baseID: "claude-opus-4.7",
    variantID: "claude-opus-4.7-1m",
    preserveExisting: false,
    limit: { context: 1000000, input: 900000 },
  },
  {
    baseID: "claude-opus-4.8",
    variantID: "claude-opus-4.8-1m",
    preserveExisting: false,
    limit: { context: 1000000, input: 900000 },
  },
  {
    baseID: "claude-sonnet-4.6",
    variantID: "claude-sonnet-4.6-1m",
    preserveExisting: false,
    limit: { context: 1000000, input: 900000 },
  },
  {
    baseID: "gpt-5.4",
    variantID: "gpt-5.4-1m",
    preserveExisting: true,
    limit: { context: 1050000, input: 922000 },
  },
  {
    baseID: "gpt-5.5",
    variantID: "gpt-5.5-1m",
    preserveExisting: true,
    limit: { context: 1050000, input: 922000 },
  },
] as const;

export const plugin: Plugin = async () => {
  return {
    provider: {
      id: "github-copilot",
      async models(provider) {
        for (const variant of MODEL_VARIANTS) {
          const base = provider.models[variant.baseID];
          if (!base) continue;
          if (variant.preserveExisting && provider.models[variant.variantID]) continue;

          const name = base.name || variant.baseID;
          provider.models[variant.variantID] = {
            ...base,
            id: variant.variantID,
            name: `${name} (1M)`,
            api: base.api ? { ...base.api } : base.api,
            limit: {
              ...(base.limit ?? {}),
              ...variant.limit,
            },
          };
        }

        return provider.models;
      },
    },
    "chat.headers": async (incoming, output) => {
      if (!incoming.model.providerID.includes("github-copilot")) return;
      output.headers["Copilot-Integration-Id"] = "copilot-developer-cli";
    },
  };
};

export default plugin;
