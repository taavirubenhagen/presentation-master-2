<script lang="ts">
    import { invoke } from '@tauri-apps/api/tauri';

    import "./styles.postcss";
</script>

<main
    class=
        "w-screen h-screen
        bg-background selection:bg-onBackground text-onBackground selection:text-background
        p-8
        flex flex-col justify-center"
>
    <div>
        1. Connect this PC to the same WiFi network as your phone.
        <br/><br/>
        2. Make sure you only start the mobile app when this desktop companion is already running.
        <br/><br/>
        3. Open a any presentation (PowerPoint, Google Slides etc.) in another window.
        <br/><br/>
        4. Keep this app running in background during your presentation.
        <br/><br/>
        5. You should then be able to control the presentation with the mobile app.
        <br/><br/>
        6. If the remote control still doesn't work, reconnect both devices to the WiFi and restart both apps.
        <br/><br/>
        7. For further troubleshooting, feedback and questions, contact me at t.ruebenhagen@gmail.com.
        {#await invoke("start_wifi_server")}
        <!-- svelte-ignore empty-block -->
        {:then error}
        <!-- svelte-ignore empty-block -->
        {/await}
    </div>
</main>