#run powershell as admin

function Merge-PullRequest {
  param (
    [string]$PullRequestId,
    [string]$SourceRepo,
    [string]$PrivateRepo,
    [string]$BranchName
  )

  # Get the fetch URL for the pull request from the GitHub API
  $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$SourceRepo/pulls/$PullRequestId"
  $fetchUrl = $response.patch_url

  # Switch to the local clone of your private repo
  Set-Location "C:\Users\USER\Speaq-ui\speaq-chatui\"

  # Check if the branch exists, if not create it
  git checkout $BranchName 2>null || git checkout -b $BranchName

  # Fetch the pull request from the fetch URL
  git fetch $fetchUrl && git checkout FETCH_HEAD

  # Merge the fetched pull request into the current branch
  git merge FETCH_HEAD

  # Push the merge to the private repository
  git push origin $BranchName
}

function Merge-PullRequests {
  param (
    [string]$SourceRepo,
    [string]$PrivateRepo
  )

  $PullRequestId = Read-Host -Prompt "Enter the number of the pull request you want to merge"
  Merge-PullRequest -PullRequestId $PullRequestId -SourceRepo $SourceRepo -PrivateRepo $PrivateRepo -BranchName "pull_request_$PullRequestId"
}

# Usage
Merge-PullRequests -SourceRepo "mckaywrigley/chatbot-ui" -PrivateRepo "TheSnowGuru/speaq-chatui"
