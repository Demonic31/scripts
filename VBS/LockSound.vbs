Set oVoice = CreateObject("SAPI.SpVoice")
set oSpFileStream = CreateObject("SAPI.SpFileStream")
oSpFileStream.Open "C:\Success.wav"
oVoice.SpeakStream oSpFileStream
oSpFileStream.Close