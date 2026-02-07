use serde::de::DeserializeOwned;
use tauri::{
    plugin::{PluginApi, PluginHandle},
    AppHandle, Runtime,
};

use crate::models::*;

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_ios_window);

// initializes the Kotlin or Swift plugin classes
pub fn init<R: Runtime, C: DeserializeOwned>(
    _app: &AppHandle<R>,
    api: PluginApi<R, C>,
) -> crate::Result<TauriPluginIosWindow<R>> {
    #[cfg(target_os = "ios")]
    let handle = api.register_ios_plugin(init_plugin_ios_window)?;
    Ok(TauriPluginIosWindow(handle))
}

/// Access to the tauri-plugin-ios-window APIs.
pub struct TauriPluginIosWindow<R: Runtime>(PluginHandle<R>);

impl<R: Runtime> TauriPluginIosWindow<R> {
    pub fn open(&self, payload: OpenRequest) -> crate::Result<()> {
        self.0
            .run_mobile_plugin("open", payload)
            .map_err(Into::into)
    }
}
