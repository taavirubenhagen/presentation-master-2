<script>
	import { fade, fly } from "svelte/transition";
	import DeviceDetector from "svelte-device-detector";

    const totalHeightFactor = 3;
    const totalHeightFactorOffset = totalHeightFactor - 1;

    let windowHeight = 1080;
    let scrollY = 0;
    
    let downloadVisible = false;
</script>


<svelte:head>
    <title>Get Presentation Master 2</title>
    <meta name="description" content="Upgraded Presentation Companion"/>
</svelte:head>


<svelte:window
    bind:innerHeight={windowHeight}
    bind:scrollY={scrollY}
/>


<main class="overflow-x-hidden overflow-y-scroll min-h-screen bg-black text-center text-white">
    {#if downloadVisible}
        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <!-- svelte-ignore a11y-no-static-element-interactions -->
        <div
            class="fixed z-40 w-screen h-screen bg-black flex flex-col lg:flex-row justify-center items-center gap-16 lg:gap-32"
            in:fade={{duration: 400}} out:fade={{duration: 400}}
            on:click={() => downloadVisible = !downloadVisible}
        >
            <a href="https://play.google.com/store/apps/details?id=tavy.presenter.presentation_master_2">
                <img class="w-32" src="/android.svg" alt="Download for Android">
            </a>
            <a href="https://apps.apple.com/us/app/presentation-master-2/id6739542508">
                <img class="w-32" src="/ios.svg" alt="Download for iOS">
            </a>
        </div>
    {/if}
    <div class="fixed z-40 top-0 w-full h-24 px-8 flex justify-between items-center">
        <a href="https://taavi.rubenhagen.com" class="text-[1.75rem] md:text-[2.325rem] font-bold" style="font-family: 'DM Mono';">
            tr.
        </a>
        <p1>
            <div class="flex gap-4">
                <div>
                    <DeviceDetector showInDevice="mobile">
                        <button
                            on:click={() => downloadVisible = !downloadVisible}
                            class=
                            "transition-all duration-[200ms] relative
                            border border-white rounded-full h-10
                            {scrollY < totalHeightFactorOffset * windowHeight - 128 && false ? ( "hover:opacity-80 " + "bg-black" + " text-white" ) : "hover:opacity-[87.5%] bg-white text-black"}
                            px-4 flex justify-center items-center gap-2 text-[0.875rem] sm:text-[1rem] capitalize"
                        >
                            {#if downloadVisible}
                                Back
                            {:else}
                                Download
                            {/if}
                        </button>
                    </DeviceDetector>
                    <DeviceDetector showInDevice="desktop">
                        <a
                            href="/download"
                            class=
                            "transition-all duration-[200ms] relative
                            border border-white rounded-full h-10
                            {scrollY < totalHeightFactorOffset * windowHeight && false ? ( "hover:opacity-80 " + "bg-black" + " text-white" ) : "hover:opacity-[87.5%] bg-white text-black"}
                            px-4 flex justify-center items-center gap-2 text-[0.875rem] sm:text-[1rem] capitalize"
                        >
                            Download Receiver
                        </a>
                    </DeviceDetector>
                </div>
                <a
                    href="https://imprint.rubenhagen.com"
                    class=
                    "transition-all duration-[200ms] relative
                    border border-white rounded-full h-10 hover:opacity-[87.5%]
                    px-4 flex justify-center items-center gap-2 text-[0.875rem] sm:text-[1rem] capitalize"
                >
                    <ma-icon href="https://imprint.rubenhagen.com" color="hsl(0deg 0% 100%)">
                        Imprint
                    </ma-icon>
                </a>
            </div>
        </p1>
    </div>
    <div class='fixed w-screen h-screen px-8 flex flex-col justify-center items-center'>
        {#if scrollY < windowHeight * 0.1875}
            <div
                in:fly={{delay: 400, duration: 400, y: 16}}
                out:fly={{duration: 400, y: -16}}
            >
                <h1>
                    Upgraded
                    <br/>
                    Presentation Companion.
                </h1>
            </div>
        {:else if scrollY > windowHeight * 1.25}
            <div class="flex flex-col items-center gap-4">
                <div
                    in:fly={{delay: 400, duration: 400, y: 16}}
                    out:fly={{duration: 400, y: 16}}
                >
                    <h1>
                        Now for iOS.
                    </h1>
                </div>
                <div
                    in:fly={{delay: 800, duration: 800, y: 16}}
                    out:fly={{duration: 400, y: 16}}
                >
                    <p3>
                        Already available on Android.
                    </p3>
                </div>
            </div>
        {/if}
    </div>
    <div
        class="relative w-screen pb-[calc(42.5vh)] md:pb-[calc(35vh)] flex flex-col justify-center items-center"
        style="height: {totalHeightFactor * 100}vh;"
    >
        <img
            src="/mockup.png"
            alt="Mockup of Presentation Master 2"
            class="h-[75vh] md:h-[87.5vh]"
        />
    </div>
</main>