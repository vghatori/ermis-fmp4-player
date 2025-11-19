import React, { useState } from "react";
import { Button, StyleSheet, TextInput } from "react-native";
import NativeFmp4Player from "./specs/NativeFmp4Player";
import StreamView from "./specs/StreamViewNativeComponent";

export default function Content() {
    const [text, setText] = useState('');
    return (
        <>
            <StreamView streamId={text != '' ? text : ""}  style={{width:'100%', height:'30%'}}/>
            <Button title="Start Streaming" onPress={() => NativeFmp4Player.startStreaming()} />
            <Button title="Stop Streaming" onPress={() => NativeFmp4Player.stopStreaming()} />
            <TextInput
                  style={styles.input}
                  placeholder="Enter StreamId here"
                  onChangeText={newText => setText(newText)}
                  value={text}
                />
        </>
    )
}

const styles = StyleSheet.create({
  input: {
    height: 40,
    borderColor: 'gray',
    borderWidth: 1,
    width: '80%',
    alignSelf:'center',
    paddingLeft:15,
    paddingRight:15
  },
});