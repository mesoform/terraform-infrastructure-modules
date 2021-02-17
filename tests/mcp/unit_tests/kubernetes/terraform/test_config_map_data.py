from sys import path, stderr
import platform

try:
    path.insert(1, '../../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)

"""
    Tests the configuration of `data` mapping. `data ` contains configuration
    data, mapped like the following:
    data = {
        api_host             = "myhost:443"
        db_host              = "dbhost:5432"
        "my_config_file.yml" = "${file("${path.module}/my_config_file.yml")}"
    }

"""
if platform.system() == "Windows":
    expected_data = {
        "mosquitto.conf": "log_dest stdout\r\nlog_type all\r\nlog_timestamp true\r\nlistener 9001\r\n",
        "test": "test"
    }
else:
    expected_data = {
        "mosquitto.conf": "log_dest stdout\nlog_type all\nlog_timestamp true\nlistener 9001\n",
        "test": "test"
    }


if __name__ == '__main__':
    python_validator(expected_data)
