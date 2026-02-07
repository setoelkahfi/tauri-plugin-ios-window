<script>
    import Greet from "./lib/Greet.svelte";
    import { open } from "tauri-plugin-ios-window-api";

    // Environment configuration
    let environment = $state("production"); // Toggle between "production" and "development"

    $effect(() => {
        console.log(`Environment: ${environment}`);
    });

    function getBaseUrl() {
        return environment === "production"
            ? "https://splitfire.ai"
            : "https://splitfire-ai-local.com:3333";
    }

    function openTauriWebsite() {
        open("https://tauri.app", "Tauri")
            .then(() => {
                console.log("Tauri website opened successfully");
            })
            .catch((error) => {
                console.error("Failed to open window:", error);
            });
    }

    async function signInWithApple() {
        try {
            const baseUrl = getBaseUrl();

            // OAuth callback configuration
            // Option 1: Custom URL scheme (recommended for mobile)
            // const redirectUri = "splitfire://oauth/callback";

            // Option 2: Localhost server (for testing/desktop)
            const redirectUri = "http://localhost:8080/oauth/callback";

            // Build the OAuth URL following SplitFire pattern
            const redirectUrl = `${baseUrl}/synch-apple/auth?redirect_uri=${encodeURIComponent(redirectUri)}`;

            console.log(`Opening Apple OAuth: ${redirectUrl}`);
            console.log(`Callback will be sent to: ${redirectUri}`);

            // Open the OAuth window
            await open(redirectUrl, "Sign in with Apple");
            console.log("Apple OAuth window opened successfully");

            // TODO: Implement OAuth callback handling
            // 1. Set up a listener for the redirect URI (deep link or local server)
            // 2. Parse the authorization code/token from the callback
            // 3. Send to your backend for validation
            // 4. Store the user session

            // Example callback handler (pseudo-code):
            // listen("oauth-callback", (event) => {
            //     const { code, state } = event.payload;
            //     // Exchange code for access token via backend
            //     fetch(`${baseUrl}/api/oauth/apple/token`, {
            //         method: "POST",
            //         body: JSON.stringify({ code, redirect_uri: redirectUri })
            //     });
            // });
        } catch (error) {
            console.error("Failed to open Apple OAuth:", error);
        }
    }

    function toggleEnvironment() {
        environment =
            environment === "production" ? "development" : "production";
    }
</script>

<main class="container">
    <h1>Welcome to Tauri!</h1>

    <div class="row">
        <a href="https://vite.dev" target="_blank">
            <img src="/vite.svg" class="logo vite" alt="Vite Logo" />
        </a>
        <a href="https://tauri.app" target="_blank">
            <img src="/tauri.svg" class="logo tauri" alt="Tauri Logo" />
        </a>
        <a href="https://svelte.dev" target="_blank">
            <img src="/svelte.svg" class="logo svelte" alt="Svelte Logo" />
        </a>
    </div>

    <p>Click on the Tauri, Vite, and Svelte logos to learn more.</p>

    <div class="row">
        <Greet />
    </div>

    <div class="button-container">
        <!-- Environment Toggle -->
        <div class="environment-toggle">
            <button onclick={toggleEnvironment} class="btn btn-secondary">
                Environment: {environment}
            </button>
            <p class="environment-url">{getBaseUrl()}</p>
        </div>

        <button onclick={openTauriWebsite} class="btn btn-primary">
            Open Tauri Website
        </button>

        <button onclick={signInWithApple} class="btn btn-apple">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path
                    d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"
                />
            </svg>
            Sign in with Apple (SplitFire)
        </button>
    </div>
</main>

<style>
    .logo.vite:hover {
        filter: drop-shadow(0 0 2em #747bff);
    }

    .logo.svelte:hover {
        filter: drop-shadow(0 0 2em #ff3e00);
    }

    .button-container {
        display: flex;
        flex-direction: column;
        gap: 1rem;
        margin-top: 2rem;
        max-width: 300px;
        margin-left: auto;
        margin-right: auto;
    }

    .btn {
        padding: 0.75rem 1.5rem;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.5rem;
    }

    .btn-primary {
        background: #1a73e8;
        color: white;
    }

    .btn-primary:hover {
        background: #1557b0;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(26, 115, 232, 0.4);
    }

    .btn-apple {
        background: #000;
        color: white;
    }

    .btn-apple:hover {
        background: #333;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
    }

    .btn:active {
        transform: translateY(0);
    }

    .btn-secondary {
        background: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background: #5a6268;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
    }

    .environment-toggle {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
        align-items: center;
        padding-bottom: 1rem;
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        margin-bottom: 1rem;
    }

    .environment-url {
        font-size: 0.875rem;
        color: #888;
        margin: 0;
    }
</style>
