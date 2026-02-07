<script>
    import Greet from "./lib/Greet.svelte";
    import { open } from "tauri-plugin-ios-window-api";

    function openTauriWebsite() {
        open("https://tauri.app")
            .then(() => {
                console.log("Tauri website opened successfully");
            })
            .catch((error) => {
                console.error("Failed to open window:", error);
            });
    }

    function signInWithApple() {
        // Apple ID authentication URL
        // In production, you would use proper OAuth flow with your client ID and redirect URI
        const appleAuthUrl =
            "https://appleid.apple.com/auth/authorize?" +
            "response_type=code&" +
            "response_mode=form_post&" +
            "client_id=YOUR_CLIENT_ID&" +
            "redirect_uri=YOUR_REDIRECT_URI&" +
            "scope=name%20email";

        open(appleAuthUrl)
            .then(() => {
                console.log("Sign in with Apple opened successfully");
            })
            .catch((error) => {
                console.error("Failed to open Sign in with Apple:", error);
            });
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
        <button onclick={openTauriWebsite} class="btn btn-primary">
            Open Tauri Website
        </button>

        <button onclick={signInWithApple} class="btn btn-apple">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
                <path
                    d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09l.01-.01zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z"
                />
            </svg>
            Sign in with Apple
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
</style>
