```
import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Image, Alert } from 'react-native';
import { CameraView, useCameraPermissions } from 'expo-camera';

export default function MissingPersonScreen() {
  const [permission, requestPermission] = useCameraPermissions();
  const [cameraVisible, setCameraVisible] = useState(false);
  const [scannedImage, setScannedImage] = useState(null);
  const [facing, setFacing] = useState('back');

  if (!permission) {
    // Camera permissions are still loading.
    return <View style={styles.container}><Text>Loading permissions...</Text></View>;
  }

  if (!permission.granted) {
    return (
      <View style={styles.container}>
        <Text style={styles.message}>We need your permission to show the camera</Text>
        <TouchableOpacity style={styles.button} onPress={requestPermission}>
            <Text style={styles.buttonText}>Grant Permission</Text>
        </TouchableOpacity>
      </View>
    );
  }

  const handleScan = () => {
    setCameraVisible(true);
  };
  
  const takePicture = () => {
      setCameraVisible(false);
      setScannedImage("https://via.placeholder.com/150"); // Mock
      Alert.alert("Match Found", "Similarity Score: 98%\nName: John Doe\nMissing since: 2025-12-01");
  };

  const toggleCameraFacing = () => {
    setFacing(current => (current === 'back' ? 'front' : 'back'));
  };

  return (
    <View style={styles.container}>
      {cameraVisible ? (
        <CameraView style={styles.camera} facing={facing}>
          <View style={styles.cameraControls}>
            <TouchableOpacity style={styles.flipButton} onPress={toggleCameraFacing}>
                <Text style={styles.flipText}>Flip Camera</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.captureButton} onPress={takePicture}>
                <View style={styles.captureInner} />
            </TouchableOpacity>

            <TouchableOpacity style={styles.closeButton} onPress={() => setCameraVisible(false)}>
                <Text style={styles.closeText}>Close</Text>
            </TouchableOpacity>
          </View>
        </CameraView>
      ) : (
        <View style={styles.content}>
            <Text style={styles.title}>Find Missing Person</Text>
            
            {scannedImage && (
                <View style={styles.resultContainer}>
                    <Text>Last Scanned:</Text>
                    <Image source={{ uri: scannedImage }} style={styles.image} />
                </View>
            )}

            <TouchableOpacity style={styles.button} onPress={handleScan}>
                <Text style={styles.buttonText}>Scan Face (Camera)</Text>
            </TouchableOpacity>
            
            <TouchableOpacity style={[styles.button, { marginTop: 10, backgroundColor: '#666' }]} onPress={() => Alert.alert("Coming Soon", "Upload feature coming soon")}>
                <Text style={styles.buttonText}>Upload Image</Text>
            </TouchableOpacity>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    justifyContent: 'center',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    marginBottom: 30,
  },
  button: {
    backgroundColor: '#4ECDC4',
    padding: 15,
    borderRadius: 10,
    width: '100%',
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: 16,
    fontWeight: 'bold',
  },
  camera: {
    flex: 1,
  },
  cameraControls: {
    flex: 1,
    backgroundColor: 'transparent',
    flexDirection: 'column',
    justifyContent: 'flex-end',
    alignItems: 'center',
    marginBottom: 30,
  },
  flipButton: {
    position: 'absolute',
    top: 40,
    right: 20,
    backgroundColor: 'rgba(0,0,0,0.5)',
    padding: 10,
    borderRadius: 5,
  },
  flipText: {
    color: 'white',
    fontSize: 14,
  },
  captureButton: {
      width: 70,
      height: 70,
      borderRadius: 35,
      backgroundColor: 'rgba(255,255,255,0.3)',
      justifyContent: 'center',
      alignItems: 'center',
      marginBottom: 20,
  },
  captureInner: {
      width: 60,
      height: 60,
      borderRadius: 30,
      backgroundColor: 'white',
  },
  closeButton: {
      marginBottom: 20,
  },
  closeText: {
      color: 'white',
      fontSize: 18,
  },
  message: {
      textAlign: 'center',
      padding: 20,
  },
  resultContainer: {
      marginBottom: 20,
      alignItems: 'center',
  },
  image: {
      width: 100,
      height: 100,
      borderRadius: 10,
      marginTop: 10,
  }
});
```
