
 - this is a comment
## Task-1 Create a VPC and Subnets

- Setup according to specifications in the assignment pdf file.

## Task-2 Create EC2 instance

- I found an issue wih this requirement. In order to access the ec2 instance in the public subnet I had to setup an internet gateway along with Route Table and Route table associations, this allowed me to ssh into the instance.

- The Key pairs issue was and still remains an issue which I would like o learn more on and in particular how caan I get it to work properly. I ran into a lot of issues with this requirement. Eventually i settled on creating a new key pair each time i do a `` terraform apply``` its not the best solution but I still have much more to learn.

- To get a public key for my key pair locally i used the below command
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/Brian-local-key 
```

## Task-3 Configure Nginx

- Setup according to specifications in the assignment pdf file.

## Task-4 Security Group Rules

- The security rules for this seemed like they were the same as was specified above.

- Setup according to specifications in the assignment pdf file.

## Task-5 Github Actions

- I had wanted to add a manual approval and follow it with a destroy stage which I have below. I ran into problems with this and as a result ended up taking out the code from the yaml but leaving it here so as to see a better way to go about it in future

```
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
```
