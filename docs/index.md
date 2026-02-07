# Tauri Plugin iOS Window

A Tauri plugin for opening modal windows with WebView on iOS, perfect for OAuth flows and external authentication.

## Features

- 🪟 **Modal Presentation** - Opens as popover on iPad, modal on iPhone
- 🎨 **Customizable UI** - Set custom titles, follows Apple HIG
- 📊 **Progress Tracking** - Built-in loading indicator and progress bar
- 🔄 **Navigation** - Back/forward swipe gestures enabled
- ✨ **Native Feel** - Follows iOS Human Interface Guidelines
- 🔐 **OAuth Ready** - Perfect for Sign in with Apple, OAuth flows

## Installation

```bash
# Install the plugin
npm install tauri-plugin-ios-window-api
# or
yarn add tauri-plugin-ios-window-api
# or
pnpm add tauri-plugin-ios-window-api
```

Add the plugin to your Tauri app's `src-tauri/Cargo.toml`:

```toml
[dependencies]
tauri-plugin-ios-window = { git = "https://github.com/yourusername/tauri-plugin-ios-window" }
```

Register the plugin in your Tauri app's `src-tauri/src/lib.rs`:

```rust
fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_ios_window::init())
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

## Usage

### Basic Example

```typescript
import { open } from "tauri-plugin-ios-window-api";

// Open a URL with default title
await open("https://example.com");

// Open with custom title
await open("https://example.com", "My Custom Title");
```

### OAuth Flow Example (SplitFire Pattern)

This example shows how to integrate with an OAuth provider like Sign in with Apple:

```typescript
import { open } from "tauri-plugin-ios-window-api";

async function signInWithApple() {
    try {
        // Your OAuth configuration
        const baseUrl = "https://splitfire.ai";
        const redirectUri = "your-app://oauth/callback";
        
        // Build OAuth URL
        const oauthUrl = `${baseUrl}/synch-apple/auth?redirect_uri=${encodeURIComponent(redirectUri)}`;
        
        // Open OAuth window
        await open(oauthUrl, "Sign in with Apple");
        
        // Handle the callback (implement based on your needs)
        // Option 1: Deep link handler
        // Option 2: Local server listener
        // Option 3: Custom URL scheme
        
    } catch (error) {
        console.error("OAuth failed:", error);
    }
}
```

### Complete OAuth Implementation

```typescript
import { open } from "tauri-plugin-ios-window-api";
import { listen } from "@tauri-apps/api/event";

async function startOAuthFlow(provider: "apple" | "spotify" | "youtube") {
    try {
        // Start local OAuth server (Rust backend)
        const port = await invoke("start_oauth_server");
        
        // Configure redirect
        const redirectUri = `http://localhost:${port}`;
        const baseUrl = "https://splitfire.ai";
        const oauthUrl = `${baseUrl}/synch-${provider}/auth?redirect_uri=${redirectUri}`;
        
        // Open OAuth window
        await open(oauthUrl, `Sign in with ${provider}`);
        
        // Listen for OAuth callback
        const unlisten = await listen("oauth-callback", (event) => {
            const { code, state } = event.payload;
            
            // Exchange code for access token
            invoke("exchange_oauth_token", { code, provider })
                .then((response) => {
                    console.log("OAuth successful:", response);
                    // Handle successful authentication
                })
                .catch((error) => {
                    console.error("Token exchange failed:", error);
                });
        });
        
    } catch (error) {
        console.error("OAuth flow failed:", error);
    }
}
```

## API Reference

### `open(url: string, title?: string): Promise<void>`

Opens a new modal window with a WebView.

**Parameters:**
- `url` (string, required) - The URL to open in the WebView
- `title` (string, optional) - Custom title for the navigation bar. Defaults to "Sign in"

**Returns:**
- `Promise<void>` - Resolves when the window is presented

**Example:**
```typescript
// Basic usage
await open("https://example.com");

// With custom title
await open("https://appleid.apple.com", "Sign in with Apple");
```

### `close(): Promise<void>`

Programmatically closes the currently opened window.

**Parameters:**
- None

**Returns:**
- `Promise<void>` - Resolves when the window is dismissed

**Example:**
```typescript
// Close the window
await close();

// Open and auto-close after delay
await open("https://example.com", "Loading...");
setTimeout(async () => {
    await close();
}, 3000);
```

## UI/UX Features

### Navigation Bar
- Clean, native iOS design
- Close button on leading edge (per Apple HIG)
- Centered title
- Activity indicator during loading
- Subtle border separator

### Progress Indicator
- 2px blue progress bar
- Smooth animations
- Auto-hides when complete
- Tracks page load progress

### WebView
- Full-screen immersive experience
- Back/forward swipe gestures
- Inline media playback
- Proper dark mode support
- Error state handling

### Modal Presentation
- **iPad**: Popover (400x600)
- **iPhone**: Full-screen modal
- Smooth dismiss animations
- Safe area aware

## Platform Support

- ✅ iOS (iPhone & iPad)
- ⚠️ Desktop (no-op, falls through to default behavior)
- ❌ Android (not supported)

## Best Practices

### OAuth Flows

1. **Use HTTPS in production**
   ```typescript
   const baseUrl = process.env.NODE_ENV === "production" 
       ? "https://splitfire.ai"
       : "https://localhost:3333";
   ```

2. **Handle redirects properly**
   - Use custom URL schemes for mobile: `your-app://oauth/callback`
   - Use localhost for testing: `http://localhost:8080/callback`
   - Always encode redirect URIs

3. **Security**
   - Use PKCE for OAuth 2.0
   - Validate state parameters
   - Store tokens securely
   - Use short-lived access tokens

4. **Error Handling**
   ```typescript
   try {
       await open(oauthUrl, "Sign in");
   } catch (error) {
       // Handle network errors
       // Show user-friendly message
       // Log for debugging
   }
   ```

### UI/UX

1. **Use descriptive titles**
   ```typescript
   await open(url, "Sign in with Apple");  // ✅ Good
   await open(url, "Sign in");              // ⚠️ Generic
   await open(url);                         // ❌ Uses default
   ```

2. **Provide feedback**
   - Show loading states before opening
   - Handle success/error after OAuth
   - Give users clear next steps

3. **Test on both devices**
   - iPad (popover experience)
   - iPhone (modal experience)

### Programmatic Closing

1. **After OAuth completion**
   ```typescript
   // Listen for OAuth callback
   listen("oauth-callback", async (event) => {
       // Process OAuth response
       await handleOAuthToken(event.payload);
       
       // Close the window
       await close();
   });
   ```

2. **Timeout scenarios**
   ```typescript
   // Auto-close if user doesn't complete within time limit
   await open(oauthUrl, "Sign in");
   
   const timeout = setTimeout(async () => {
       await close();
       showMessage("Authentication timed out");
   }, 60000); // 1 minute
   
   // Clear timeout if user completes
   listen("oauth-complete", () => clearTimeout(timeout));
   ```

3. **Error handling**
   ```typescript
   try {
       await open(url, "Sign in");
   } catch (error) {
       // If window fails to open, don't try to close
       console.error("Failed to open:", error);
       return;
   }
   
   // Later, close if needed
   try {
       await close();
   } catch (error) {
       // Window may already be closed by user
       console.log("Window already closed");
   }
   ```

## Example App

Check out the complete example in `examples/tauri-app`:

```bash
cd examples/tauri-app
npm install
npm run tauri ios dev
```

## Development

```bash
# Clone the repository
git clone https://github.com/yourusername/tauri-plugin-ios-window

# Install dependencies
npm install

# Build the plugin
npm run build

# Run example
cd examples/tauri-app
npm run tauri ios dev
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT

## Credits

Built for [SplitFire](https://splitfire.ai) - OAuth pattern inspired by production usage.
