package cmd

import (
	"cluster-provisioning-multiple/pkg/logger"
	"cluster-provisioning-multiple/pkg/utils"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strconv"

	"github.com/spf13/cobra"
)

type strCreateCmd struct {
	verbose     bool
	cnt         int
	clusterType string
	kubeconfig  string
}

func createCmd() *cobra.Command {
	createCmd := &strCreateCmd{}
	cmd := &cobra.Command{
		Use:          "create [flags]",
		Short:        "Create kubernetes cluster",
		Long:         "",
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, args []string) error {
			return createCmd.run()
		},
	}

	// SubCommand add
	cmd.AddCommand(emptyCmd())

	// Flags
	f := cmd.Flags()
	f.BoolVar(&createCmd.verbose, "vvv", false, "verbose")
	f.IntVar(&createCmd.cnt, "count", 0, "multiple cluster count")
	f.StringVarP(&createCmd.clusterType, "type", "t", "kubeadm", "cluster type")
	f.StringVar(&createCmd.kubeconfig, "kubeconfig", "", "kubeconfig is a required flag. <Please enter the kubeconfig path here.>")

	// define required local flag
	// cmd.MarkFlagRequired("kubeconfig")

	return cmd
}

func (c *strCreateCmd) run() error {
	workDir, _ := os.Getwd()
	logger.Infof("Start provisioning for cloud infrastructure")

	if err := c.init(workDir); err != nil {
		return err
	}
	return nil
}

func (c *strCreateCmd) init(workDir string) error {

	// 필수 옵션 체크
	if c.kubeconfig == "" {
		logger.Fatal(fmt.Errorf("[ERROR]: %s", "To run this an kubeconfig option in <Path to kubeconfig> must be specified."))
	}

	clusterTypeDir := workDir + "/pkg/cluster/capi_kubeadm_openstack_multiple/"

	if c.clusterType == "kubeadm" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_kubeadm_openstack_multiple/"
	} else if c.clusterType == "k3s" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_k3s_openstack_multiple/"
	} else if c.clusterType == "microk8s" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_mk8s_openstack_multiple/"
	}

	// kubeconfig copy
	key := filepath.Base(c.kubeconfig)
	keyPath, _ := filepath.Abs(c.kubeconfig)
	if err := utils.CopyFile(keyPath, clusterTypeDir+key); err != nil {
		logger.Fatal(fmt.Errorf("[ERROR]: %s", err))
	}

	// Command binary Path
	commandArgs := []string{}

	count := ""
	if c.cnt > 0 {
		count = strconv.Itoa(c.cnt)
	}

	// 디렉토리로 이동
	if err := os.Chdir(clusterTypeDir); err != nil {
		logger.Fatal(fmt.Errorf("[ERROR]: 디렉토리 이동 중 오류 발생: %s", err))

	}

	// 초기화 Command 입력
	cmdDefault := []string{
		"./1.generate.sh",
		count,
	}

	commandArgs = append(commandArgs, cmdDefault...)

	// 초기화 스크립트 실행
	cmd := utils.ExecCommand("/bin/sh", commandArgs)
	out, err := cmd.CombinedOutput()
	fmt.Println(string(out))
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			fmt.Println("ExitError:", string(ee.Stderr))
		} else {
			fmt.Println("err:", err)
		}
	}

	// 생성 Command 입력
	commandArgs = []string{}
	cmdCreate := []string{
		"./2.create.sh",
	}

	commandArgs = append(commandArgs, cmdCreate...)

	// 생성 스크립트 실행
	cmd = utils.ExecCommand("/bin/sh", commandArgs)
	out, err = cmd.CombinedOutput()
	fmt.Println(string(out))
	if err != nil {
		if ee, ok := err.(*exec.ExitError); ok {
			fmt.Println("ExitError:", string(ee.Stderr))
		} else {
			fmt.Println("err:", err)
		}
	}

	return nil
}
