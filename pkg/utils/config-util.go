package utils

import (
	"edgecraft-carrier/pkg/logger"
	"edgecraft-carrier/pkg/model"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"reflect"
	"strings"

	"github.com/pelletier/go-toml"
)

var errorCnt = 0

func GetAddonTomlConfig(path string) (model.AddonToml, error) {

	errorCnt = 0
	// configFullPath := workDir + "/" + conf.KoreonConfigFile

	var c []byte
	var err error

	if !FileExists(path) {
		logger.Fatal(fmt.Sprintf("%s file is not found. Run koreonctl addon init first", path))
		os.Exit(1)
	}

	c, err = ioutil.ReadFile(path)
	if err != nil {
		logger.Fatal(err.Error())
		os.Exit(1)
	}

	str := string(c)
	str = strings.Replace(str, "\\", "/", -1)
	c = []byte(str)

	var addonToml = model.AddonToml{}
	err = toml.Unmarshal(c, &addonToml)
	if err != nil {
		logger.Fatal(err.Error())
		errorCnt++
	}

	return addonToml, err
}

func setField(item interface{}, supportList map[string]interface{}) ([]byte, error) {
	v := reflect.ValueOf(item).Elem()
	if !v.CanAddr() {
		return nil, fmt.Errorf("cannot assign to the item passed, item must be a pointer in order to assign")
	}

	result := make(map[string]interface{})
	versions := make(map[string]interface{})

	for i := 0; i < v.NumField(); i++ {
		typeField := v.Type().Field(i)
		tag := typeField.Tag.Get("validate")
		r := strings.Split(tag, ",")
		if len(r) != 2 {
			return nil, fmt.Errorf("tag entry error in %s field", typeField.Name)
		}
		value := IsSupportVersion(fmt.Sprintf("%v", supportList[string(r[0])]), r[1])
		v.Field(i).SetString(value)

		// list Versions
		versions[typeField.Name] = ListSupportVersion(r[1])
		result["List"+v.Type().Name()] = versions
	}

	data, err := json.Marshal(result)
	if err != nil {
		return nil, err
	}
	return data, nil
}
