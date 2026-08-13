param(
    [string]$FixturePath = ".\tests\council\fixtures"
)

$ErrorActionPreference = "Stop"

function Get-ConsensusResult {
    param(
        [object]$Case
    )

    $reviews = @($Case.reviews)

    if ($reviews.Count -eq 0) {
        return "NOT_REACHED"
    }

    $providerFailure = $reviews | Where-Object {
        $_.recommendation -eq "PROVIDER_FAILURE"
    }

    if ($providerFailure) {
        return "NOT_REACHED"
    }

    $criticalObjection = $reviews | Where-Object {
        $_.critical_objection -eq $true
    }

    if ($criticalObjection) {
        return "BLOCKED"
    }

    if ($Case.acceptance_criteria -and
        $Case.acceptance_criteria.mandatory_satisfied -eq $true) {

        $allApprove = ($reviews | Where-Object {
            $_.recommendation -ne "APPROVE"
        }).Count -eq 0

        if ($allApprove) {
            return "REACHED"
        }
    }

    $reviewRequired = $reviews | Where-Object {
        $_.recommendation -eq "REVIEW_REQUIRED"
    }

    if ($reviewRequired) {
        return "NOT_REACHED"
    }

    $conditional = $reviews | Where-Object {
        $_.recommendation -eq "APPROVE_WITH_CONDITIONS"
    }

    if ($conditional) {
        return "CONDITIONAL"
    }

    $allApprove = ($reviews | Where-Object {
        $_.recommendation -ne "APPROVE"
    }).Count -eq 0

    if ($allApprove) {
        return "REACHED"
    }

    return "NOT_REACHED"
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " OHTATS AI COUNCIL TEST RUNNER v0.1" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

$fixtures = Get-ChildItem $FixturePath -Filter "*.json" -File |
    Sort-Object Name

$total = 0
$passed = 0
$failed = 0

foreach ($fixture in $fixtures) {

    $total++

    $case = Get-Content $fixture.FullName -Raw |
        ConvertFrom-Json

    $actual = Get-ConsensusResult -Case $case
    $expected = [string]$case.expected_consensus

    if ($actual -eq $expected) {

        $passed++

        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " $($case.test_id) - $($case.title)"
        Write-Host "       Expected : $expected"
        Write-Host "       Actual   : $actual"
    }
    else {

        $failed++

        Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
        Write-Host " $($case.test_id) - $($case.title)"
        Write-Host "       Expected : $expected"
        Write-Host "       Actual   : $actual"
    }

    Write-Host ""
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " TEST SUMMARY" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

Write-Host "Total : $total"
Write-Host "Passed: $passed" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red

Write-Host ""

if ($failed -gt 0) {
    Write-Host "COUNCIL TEST RESULT: FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "COUNCIL TEST RESULT: PASSED" -ForegroundColor Green
exit 0
