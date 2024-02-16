

## Task-1

## Task-2
```
terraform plan -generate-config-out=generated.tf
```

```
ssh -i ~/Downloads/Brian-Terraform-local.pem ec2-user@3.254.231.177
```

## Task-3

## Task-4

## Task-5


  request-destroy-approval: 
    name: Request Destroy Approval
    runs-on: ubuntu-latest
    needs: terraform
    if: ${{ always() && github.ref == 'refs/heads/main' }} 
    steps:
      - name: Approval Required
        uses: marketplace/find-something-good.
        with:
          approvers: "Brianconn71"

  terraform_destroy:
    name: Terraform Destroy
    runs-on: ubuntu-latest
    needs: request-destroy-approval
    if: ${{ needs.request-destroy-approval.outputs.approved == 'true' }}
    steps:
      - name: Terraform Destroy
        working-directory: ./Task-5
        run: terraform destroy -auto-approve 
