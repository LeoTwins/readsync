package core

import (
	"fmt"
	"os"
	"strings"
)

type (
	Config struct {
		Port        string
		Env         string
		CorsOrigins []string

		DB DBConfig
	}

	DBConfig struct {
		Host     string
		Port     string
		User     string
		Password string
		Name     string
		SSLMode  string
	}
)

func LoadConfig() (*Config, error) {
	config := &Config{
		Port:        os.Getenv("PORT"),
		Env:         os.Getenv("APP_ENV"),
		CorsOrigins: strings.Split(os.Getenv("CORS_ORIGINS"), ","),

		DB: DBConfig{
			Host:     os.Getenv("DB_HOST"),
			Port:     os.Getenv("DB_PORT"),
			User:     os.Getenv("DB_USER"),
			Password: os.Getenv("DB_PASSWORD"),
			Name:     os.Getenv("DB_NAME"),
			SSLMode:  getEnvOrDefault("DB_SSLMODE", "disable"),
		},
	}

	var missingEnvVars []string
	for _, err := range validateConfig(config) {
		if err != nil {
			missingEnvVars = append(missingEnvVars, err.Error())
		}
	}

	if len(missingEnvVars) > 0 {
		return nil, fmt.Errorf("required environment variables are not set: %s", strings.Join(missingEnvVars, ", "))
	}

	return config, nil
}

func validateConfig(config *Config) []error {
	var errors []error

	// Config構造体の必須フィールドを検証
	if config.Port == "" {
		errors = append(errors, fmt.Errorf("PORT"))
	}
	if config.Env == "" {
		errors = append(errors, fmt.Errorf("APP_ENV"))
	}
	if len(config.CorsOrigins) == 0 || (len(config.CorsOrigins) == 1 && config.CorsOrigins[0] == "") {
		errors = append(errors, fmt.Errorf("CORS_ORIGINS"))
	}

	// DBConfig構造体の必須フィールドを検証
	if config.DB.Host == "" {
		errors = append(errors, fmt.Errorf("DB_HOST"))
	}
	if config.DB.Port == "" {
		errors = append(errors, fmt.Errorf("DB_PORT"))
	}
	if config.DB.User == "" {
		errors = append(errors, fmt.Errorf("DB_USER"))
	}
	if config.DB.Password == "" {
		errors = append(errors, fmt.Errorf("DB_PASSWORD"))
	}
	if config.DB.Name == "" {
		errors = append(errors, fmt.Errorf("DB_NAME"))
	}

	return errors
}

// 環境変数を取得し、設定されていない場合はデフォルト値を返す
func getEnvOrDefault(key, defaultValue string) string {
	if value, exists := os.LookupEnv(key); exists {
		return value
	}
	return defaultValue
}

func LoadTestDBConfig() DBConfig {
	return DBConfig{
		Host:     getEnvOrDefault("TEST_DB_HOST", "localhost"),
		Port:     getEnvOrDefault("TEST_DB_PORT", "5433"),
		User:     getEnvOrDefault("TEST_DB_USER", "postgres"),
		Password: getEnvOrDefault("TEST_DB_PASSWORD", "password"),
		Name:     getEnvOrDefault("TEST_DB_NAME", "kaimon_test"),
		SSLMode:  getEnvOrDefault("TEST_DB_SSLMODE", "disable"),
	}
}

func (c DBConfig) DSN() string {
	sslMode := c.SSLMode
	if sslMode == "" {
		sslMode = "disable"
	}
	return fmt.Sprintf("host=%s port=%s dbname=%s user=%s password=%s sslmode=%s",
		c.Host, c.Port, c.Name, c.User, c.Password, sslMode)
}
