import Foundation
import XCPlayground
import Accelerate

func graph <T>(sequence: [T], title: String) {
    for x in sequence {
        XCPCaptureValue(title, x)
    }
}

let frequency1 = 4.0
let phase1 = 0.0
let amplitude1 = 2.0

let sineWave = (0..<64).map {
    amplitude1 * sin(2.0 * M_PI / Double(64) * Double($0) * frequency1 + phase1)
}

let frequency2 = 1.0
let phase2 = M_PI / 2.0
let amplitude2 = 1.0
let sineWave2 = (0..<64).map {
    amplitude2 * sin(2.0 * M_PI / Double(64) * Double($0) * frequency2 + phase2)
}

graph(sineWave, "Sine wave 1")
graph(sineWave2, "Sine wave 2")

// Simple loop-based array addition
var combinedSineWave = [Double](count: 64, repeatedValue: 0.0)

for currentIndex in 0..<64 {
    combinedSineWave[currentIndex] = sineWave[currentIndex] + sineWave2[currentIndex]
}

// Accelerate-enabled array addition
infix operator  +++ {}

func +++ (a: [Double], b: [Double]) -> [Double] {
    assert(a.count == b.count, "Expected arrays of the same length, instead got arrays of two different lengths")
    
    var result = [Double](count:a.count, repeatedValue:0.0)
    vDSP_vaddD(a, 1, b, 1, &result, 1, UInt(a.count))
    return result
}

let combinedSineWave2 = sineWave +++ sineWave2

graph(combinedSineWave, "Combined wave (loop addition)")
graph(combinedSineWave2, "Combined wave (Accelerate)")

// Wrapping vecLib in overloaded functions
func sqrt(x: [Double]) -> [Double] {
    var results = [Double](count:x.count, repeatedValue:0.0)
    
    vvsqrt(&results, x, [Int32(x.count)])
    
    return results
}

sqrt(4.0)

sqrt([4.0, 3.0, 16.0])


// Accelerate-enabled FFT
let fft_weights: FFTSetupD = vDSP_create_fftsetupD(vDSP_Length(log2(Float(64))), FFTRadix(kFFTRadix2))

func fft(var inputArray:[Double]) -> [Double] {
    var fftMagnitudes = [Double](count:inputArray.count, repeatedValue:0.0)
    var zeroArray = [Double](count:inputArray.count, repeatedValue:0.0)
    var splitComplexInput = DSPDoubleSplitComplex(realp: &inputArray, imagp: &zeroArray)
    
    vDSP_fft_zipD(fft_weights, &splitComplexInput, 1, vDSP_Length(log2(CDouble(inputArray.count))), FFTDirection(FFT_FORWARD));
    vDSP_zvmagsD(&splitComplexInput, 1, &fftMagnitudes, 1, vDSP_Length(inputArray.count));
    
    let roots = sqrt(fftMagnitudes) // vDSP_zvmagsD returns squares of the FFT magnitudes, so take the root here
    var normalizedValues = [Double](count:inputArray.count, repeatedValue:0.0)
    
    vDSP_vsmulD(roots, vDSP_Stride(1), [2.0 / Double(inputArray.count)], &normalizedValues, vDSP_Stride(1), vDSP_Length(inputArray.count))
    return normalizedValues
}

let fftOfWave1 = fft(sineWave)
let fftOfWave2 = fft(sineWave2)
let fftOfWave3 = fft(combinedSineWave)

fftOfWave1.filter {$0 > 0.1}

//func filter(includeElement: (T) -> Bool) -> [T]

extension Slice {
    func filterWithIndicesAdjustedByMultiplier(indexAdjustment:Double, includeElement: (T) -> Bool) -> [(Double, T)] {
        var filterResults: [(Double, T)] = []
        for (index, arrayElement) in enumerate(self) {
            let t = arrayElement as T;
            if includeElement(t) {
                filterResults.append(Double(index) * indexAdjustment, t)
            }
        }
        return filterResults
    }
}

graph(fftOfWave1, "FFT of sine wave 1")
graph(fftOfWave2, "FFT of sine wave 2")
graph(fftOfWave3, "FFT of combined sine waves")

let amplitudeThreshold = 0.00001
func identifyFrequenciesAndAmplitudesOfWaveform(waveform:[Double]) -> [(Double, Double)] {
    let fftOfWaveform = fft(waveform)
    let halfFFT = fftOfWaveform[0..<(waveform.count / 2)]
    return halfFFT.filterWithIndicesAdjustedByMultiplier(1.0) { $0 > amplitudeThreshold }
}

identifyFrequenciesAndAmplitudesOfWaveform(sineWave)
identifyFrequenciesAndAmplitudesOfWaveform(sineWave2)
identifyFrequenciesAndAmplitudesOfWaveform(combinedSineWave)
