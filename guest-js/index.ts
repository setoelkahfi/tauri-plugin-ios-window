import { invoke } from "@tauri-apps/api/core";

export async function open(url: string): Promise<void> {
  await invoke("plugin:ios-window|open", {
    payload: {
      url,
    },
  });
}
