# Voice Recognition iOS App
This repository contains the implementation of a naive iOS application for voice recognition, as the Take Home Challenge. The application is designed to recognize and process user voice inputs.

## Technologies Used
The main technology used in this project is the **SFSpeechRecognizer** class from the Apple’s **Speech** framework. The SFSpeechRecognizer class provides a convenient, but limited API for working with user speech recognition. After exploring third-party frameworks, I came across Google's GoogleSpeechToText. However, since it operates identically, the decision was made to use a naive framework.

## Professional Use
While the SFSpeechRecognizer class is the best solution for this particular task, it is not intended for voice control with command tracking. For that purpose, the **SFCustomLanguageModelData** class is available. It is specifically designed for voice control and is expected to be widely used in voice control tasks in the future. However, it is currently in the Beta version and cannot be used in production code. Nevertheless, once it is fully released, this class is expected to provide significantly improved performance.

## Pronunciation
To ensure accurate and precise speech recognition, I have used the voice of a professional voice-over artist. I have complete confidence in the pronunciation accuracy of the voice commands.
Algorithm for Recognizing Two-Digit Numbers
Due to the limitations of speech recognition technologies, reliably distinguishing a two-digit number from two single-digit numbers without a high risk of mistake is practically impossible. It recognizes “one one”, but sometimes randomly splits it into “11”. After exploring various approaches, I have reached a solution to process numbers digit by digit and only consider them if the word "and" appears between them. This approach has enabled my program to function reliably, meeting the requirements while maintaining flexible and easily testable code.

## Testing
In addition to developing a high-quality speech processing class, I aimed to create a convenient API that would facilitate class extension, usage, and testing. I have adapted the SpeechHandler class for testing purposes and have written a set of unit tests to verify the functionality of my class. With these tests in place, **it is no longer necessary to run the entire application** to validate its behavior; running the tests alone provides confidence in the correctness of the algorithm.
