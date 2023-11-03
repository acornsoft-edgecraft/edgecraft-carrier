/*
Copyright © 2022 NAME HERE <EMAIL ADDRESS>
*/
package main

import (
	"cluster-provisioning-multiple/cmd"
	"fmt"
	"time"
)

func timeElapsed() func() {
	start := time.Now()
	return func() {
		timeElapsed := time.Since(start)
		fmt.Println("Duration", timeElapsed, "time")
	}
}

func main() {
	defer timeElapsed()()
	cmd.Execute()
}
