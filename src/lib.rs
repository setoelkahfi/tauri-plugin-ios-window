use tauri::{
    plugin::{Builder, TauriPlugin},
    Manager, Runtime,
};

pub use models::*;

#[cfg(desktop)]
mod desktop;
#[cfg(mobile)]
mod mobile;

mod commands;
mod error;
mod models;

pub use error::{Error, Result};

#[cfg(desktop)]
use desktop::TauriPluginIosWindow;
#[cfg(mobile)]
use mobile::TauriPluginIosWindow;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the tauri-plugin-ios-window APIs.
pub trait TauriPluginIosWindowExt<R: Runtime> {
    fn tauri_plugin_ios_window(&self) -> &TauriPluginIosWindow<R>;
}

impl<R: Runtime, T: Manager<R>> crate::TauriPluginIosWindowExt<R> for T {
    fn tauri_plugin_ios_window(&self) -> &TauriPluginIosWindow<R> {
        self.state::<TauriPluginIosWindow<R>>().inner()
    }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
    Builder::new("ios-window")
        .invoke_handler(tauri::generate_handler![commands::open])
        .setup(|app, api| {
            #[cfg(mobile)]
            let tauri_plugin_ios_window = mobile::init(app, api)?;
            #[cfg(desktop)]
            let tauri_plugin_ios_window = desktop::init(app, api)?;
            app.manage(tauri_plugin_ios_window);
            Ok(())
        })
        .build()
}
