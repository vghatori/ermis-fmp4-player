import React from "react";
import { Button } from "react-native";
import NativeFmp4Player from "./specs/NativeFmp4Player";
import StreamView from "./specs/StreamViewNativeComponent";

export default function Content() {
    return (
        <>
            <StreamView streamId='abc' style={{width:'100%', height:'30%'}}/>
            <Button title="Start Streaming" onPress={() => NativeFmp4Player.startStreaming()} />
            <Button title="Stop Streaming" onPress={() => NativeFmp4Player.stopStreaming()} />
        </>
    )
}