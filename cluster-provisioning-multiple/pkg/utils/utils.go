package utils

import (
	"bufio"
	"cluster-provisioning-multiple/pkg/logger"
	"fmt"
	"os"
	"os/exec"
	"runtime"
	"strings"
)

func ExecCommand(c string, commandArgs []string) *exec.Cmd {
	binary, lookErr := exec.LookPath(c)
	if lookErr != nil {
		logger.Fatal(lookErr)
	}

	cmd := exec.Command(binary, commandArgs...)
	return cmd
}

func CheckUserInput(prompt string, checkWord string) bool {
	var res string
	fmt.Print(prompt)

	reader := bufio.NewReader(os.Stdin)
	buf, _ := reader.ReadString('\n')

	if runtime.GOOS == "windows" {
		res = strings.Split(buf, "\r\n")[0]
	} else {
		res = strings.Split(buf, "\n")[0]
	}

	if res == checkWord {
		return true
	}

	return false
}
