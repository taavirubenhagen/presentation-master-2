<script lang="ts">
    import { invoke } from '@tauri-apps/api/core';

    //import "./styles.postcss";
</script>

<main>
    Connect your PC to the same WiFi network as your phone and open any presentation (PowerPoint, Google Slides, etc.).
    <br/>
    Keep this desktop companion app open in background. Make sure it is running before you start the mobile app.
    <br/>
    You should then be able to open the mobile app and control the presentation via WiFi.
    <br/><br/>
    If it doesn't work, make sure you have granted the app the necessary permissions,
    close/disconnect everything and repeat the steps above.
    <br/>
    For further troubleshooting, feedback and questions, email me at t.ruebenhagen@gmail.com.
    <br/><br/>
    <div style="color: #F7F7F7;">
        {#await invoke("start_wifi_server")}
            [starting]
        {:then error}
            [finished]
        {/await}
    </div>
</main>