package cmd

import (
	"cluster-provisioning-multiple/pkg/logger"
	"cluster-provisioning-multiple/pkg/utils"
	"fmt"
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

type strDeleteCmd struct {
	verbose     bool
	clusterType string
}

func deleteCmd() *cobra.Command {
	deleteCmd := &strDeleteCmd{}
	cmd := &cobra.Command{
		Use:          "delete [flags]",
		Short:        "delete kubernetes cluster",
		Long:         "",
		SilenceUsage: true,
		RunE: func(cmd *cobra.Command, args []string) error {
			return deleteCmd.run()
		},
	}

	// SubCommand add
	cmd.AddCommand(emptyCmd())

	// Flags
	f := cmd.Flags()
	f.BoolVar(&deleteCmd.verbose, "vvv", false, "verbose")

	// define required local flag
	// cmd.MarkFlagRequired("kubeconfig")

	return cmd
}

func (c *strDeleteCmd) run() error {
	workDir, _ := os.Getwd()
	logger.Infof("Start provisioning for cloud infrastructure")

	if err := c.init(workDir); err != nil {
		return err
	}
	return nil
}

func (c *strDeleteCmd) init(workDir string) error {

	// 필수 옵션 체크

	clusterTypeDir := workDir + "/pkg/cluster/capi_kubeadm_openstack_multiple/"

	if c.clusterType == "kubeadm" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_kubeadm_openstack_multiple/"
	} else if c.clusterType == "k3s" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_k3s_openstack_multiple/"
	} else if c.clusterType == "microk8s" {
		clusterTypeDir = workDir + "/pkg/cluster/capi_mk8s_openstack_multiple/"
	}

	// 디렉토리로 이동
	if err := os.Chdir(clusterTypeDir); err != nil {
		logger.Fatal(fmt.Errorf("[ERROR]: 디렉토리 이동 중 오류 발생: %s", err))

	}

	// Command 입력
	commandArgs := []string{}
	cmdDefault := []string{
		"./5-1.watch.sh",
	}

	commandArgs = append(commandArgs, cmdDefault...)

	// 스크립트 실행
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

	if !utils.CheckUserInput(" ⦿  해당 클러스터를 삭제하시겠습니까? [y/n] ", "y") {
		fmt.Println("nothing to changed. exit")
		os.Exit(1)
	}

	// Command 입력
	commandArgs = []string{}
	cmdDefault = []string{
		"./3.delete.sh",
	}

	commandArgs = append(commandArgs, cmdDefault...)

	// 스크립트 실행
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
