import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <h1 className="text-5xl font-extrabold text-gradient-to-r from-cyan-400 to-purple-600">
        KinetiSense
      </h1>
      <p className="mt-2 text-lg text-gray-600">
        Real-time Human Activity Recognition Powered by LLMs
      </p>
    </>
  )
}

export default App
