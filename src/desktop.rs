use serde::de::DeserializeOwned;
use tauri::{plugin::PluginApi, AppHandle, Runtime};

use crate::models::*;

pub fn init<R: Runtime, C: DeserializeOwned>(
    app: &AppHandle<R>,
    _api: PluginApi<R, C>,
) -> crate::Result<TauriPluginIosWindow<R>> {
    Ok(TauriPluginIosWindow(app.clone()))
}

/// Access to the tauri-plugin-ios-window APIs.
pub struct TauriPluginIosWindow<R: Runtime>(AppHandle<R>);

impl<R: Runtime> TauriPluginIosWindow<R> {
    pub fn open(&self, payload: OpenRequest) -> crate::Result<()> {
        // Desktop implementation - no-op since this is iOS-specific
        println!("Opening window with URL: {}", payload.url);
        Ok(())
    }
}
