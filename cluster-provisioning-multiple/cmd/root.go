package cmd

import (
	"os"

	"cluster-provisioning-multiple/pkg/logger"

	"github.com/spf13/cobra"
)

var (
	version bool
)

// RootCmd represents the base command when called without any subcommands
var RootCmd = &cobra.Command{
	Use:          "edgecraft_cpm",
	Short:        "Install kubernetes cluster for multiple cluster",
	Long:         `It install kubernetes cluster.`,
	SilenceUsage: true,
	Run:          func(cmd *cobra.Command, args []string) {},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	if err := RootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	RootCmd.CompletionOptions.HiddenDefaultCmd = true

	RootCmd.SetFlagErrorFunc(func(c *cobra.Command, err error) error {
		c.Println("Error: ", err)
		c.Println(c.UsageString())
		os.Exit(1)
		return nil
	})

	// 하위 명령 추가
	RootCmd.AddCommand(
		createCmd(),
		statusCmd(),
		deleteCmd(),
	)
}

func initConfig() {
	// create default logger
	err := logger.New()
	if err != nil {
		logger.Fatalf("Could not instantiate log %ss", err.Error())
	}
}
