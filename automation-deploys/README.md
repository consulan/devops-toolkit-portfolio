# automation-deploys

This subdirectory contains the deployment automation role for the DevOps Toolkit Portfolio project.

## Description

The `automation-deploys` role streamlines the automated deployment of applications and services, ensuring consistency and efficiency throughout the deployment process.

## Main Features

- Scripts and playbooks for automated deployment.
- Integration with CI/CD tools.
- Configurable settings for multiple environments.

## Usage

1. Clone the main repository.
2. Navigate to the `automation-deploys` subdirectory.
3. Run the deployment using:

    ```bash
    ansible-playbook -i inventory.ini zabbix.yml
    ```

4. Follow the specific instructions in the configuration files and scripts.

## Requirements

- Ansible installed.
- Access to target environments.
- Necessary credentials for deployment.

## Contribution

Contributions are welcome. Please open an issue or submit a pull request for suggestions or improvements.

## License

See the LICENSE file in the main repository for details.
