package cmd

import (
	"context"
	"encoding/json"
	"os"

	"contabo.com/cli/cntb/client"
	contaboCmd "contabo.com/cli/cntb/cmd"
	"contabo.com/cli/cntb/cmd/util"
	"contabo.com/cli/cntb/outputFormatter"
	uuid "github.com/satori/go.uuid"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var tagsGetCmd = &cobra.Command{
	Use:   "tags",
	Short: "All about your tags",
	Long:  `Retrieves information about one or multiple tags. Filter by name.`,
	Run: func(cmd *cobra.Command, args []string) {
		ApiRetrieveTagListRequest := client.ApiClient().
			TagsApi.RetrieveTagList(context.Background()).
			XRequestId(uuid.NewV4().String()).
			Page(contaboCmd.Page).
			Size(contaboCmd.Size).
			OrderBy([]string{contaboCmd.OrderBy})

		if cmd.Flags().Changed("tagName") {
			ApiRetrieveTagListRequest = ApiRetrieveTagListRequest.Name(tagNameFilter)
		}

		resp, httpResp, err := ApiRetrieveTagListRequest.Execute()

		util.HandleErrors(err, httpResp, "while retrieving tags")

		responseJson, _ := json.Marshal(resp.Data)

		configFormatter := outputFormatter.FormatterConfig{
			Filter:     []string{"tagId", "name", "color"},
			WideFilter: []string{"tagId", "name", "color"},
			JsonPath:   contaboCmd.OutputFormatDetails}

		util.HandleResponse(responseJson, configFormatter)
	},
	Args: func(cmd *cobra.Command, args []string) error {
		contaboCmd.ValidateOutputFormat()
		if len(args) > 1 {
			cmd.Help()
			os.Exit(0)
		}

		return nil
	},
}

func init() {
	contaboCmd.GetCmd.AddCommand(tagsGetCmd)

	tagsGetCmd.Flags().StringVarP(&tagNameFilter, "tagName", "t", "", `Filter by tag name`)
	viper.BindPFlag("tagName", tagsGetCmd.Flags().Lookup("tagName"))
}
