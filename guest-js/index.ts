import { invoke } from "@tauri-apps/api/core";

export async function open(url: string, title?: string): Promise<void> {
  await invoke("plugin:ios-window|open", {
    payload: {
      url,
      title,
    },
  });
}

export async function close(): Promise<void> {
  await invoke("plugin:ios-window|close");
}
