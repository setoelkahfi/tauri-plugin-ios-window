use tauri::{command, AppHandle, Runtime};

use crate::models::*;
use crate::Result;
use crate::TauriPluginIosWindowExt;

#[command]
pub(crate) async fn open<R: Runtime>(app: AppHandle<R>, payload: OpenRequest) -> Result<()> {
    app.tauri_plugin_ios_window().open(payload)
}

#[command]
pub(crate) async fn close<R: Runtime>(app: AppHandle<R>) -> Result<()> {
    app.tauri_plugin_ios_window().close()
}
