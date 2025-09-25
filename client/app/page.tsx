"use client";

import { useEffect, useState } from "react";
import styles from "./page.module.css";

export default function Home() {
  const [message, setMessage] = useState<string>("Loading...");

  useEffect(() => {
    const fetchMessage = async () => {
      try {
        const res = await fetch("/hello");
        const text = await res.text();
        setMessage(text);
      } catch (err: unknown) {
        if (err instanceof Error) {
          setMessage("Error: " + err.message);
        } else {
          setMessage("An unknown error occurred");
        }
      }
    };

    fetchMessage();
  }, []);

  return (
    <main className={styles.main}>
      <h1 className={styles.title}>Spring Boot says:</h1>
      <p className={styles.message}>{message}</p>
    </main>
  );
}
