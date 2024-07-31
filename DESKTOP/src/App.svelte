<script lang="ts">
    import { invoke } from '@tauri-apps/api/tauri';

    import "./styles.postcss";
</script>

<main
    class=
        "w-screen h-screen
        bg-background selection:bg-onBackground text-onBackground selection:text-background
        pb-4
        flex justify-center items-center text-center"
>
    <div>
        {#await invoke("start_wifi_server")}
            Use the mobile app to connect.
            <!--<br/>
            (
            <!-TODO: Add link + icon->
            <a href="https://youtube.com" class="inline underline underline-offset-8">Video tutorial
                <xml version="1.0" encoding="UTF-8">
                <svg class="inline" width="16px" height="16px" viewBox="0 0 24 24" stroke-width="1.5" fill="none" xmlns="http://www.w3.org/2000/svg" color="#000000">
                    <path d="M21 3h-6m6 0l-9 9m9-9v6" stroke="#f5f5f5" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <path d="M21 13v6a2 2 0 01-2 2H5a2 2 0 01-2-2V5a2 2 0 012-2h6" stroke="#f5f5f5" stroke-width="1.5" stroke-linecap="round"></path>
                </svg>
            </a>
            )-->
        {:then error}
            Connect to WiFi and restart the app.
            If the problem persists, please contact the developer: taavi.ruebenhagen@gmail.com
        {/await}
    </div>
</main>