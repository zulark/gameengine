param()

$compiler = "C:\msys64\mingw64\bin\g++.exe"
$env:PATH = "C:\msys64\mingw64\bin;" + $env:PATH
$cwd = $PSScriptRoot

$sources = @(
    "imgui\imgui.cpp"
    "imgui\imgui_draw.cpp"
    "imgui\imgui_tables.cpp"
    "imgui\imgui_widgets.cpp"
    "imgui\imgui-SFML.cpp"
    "main.cpp"
)

$includes = "-I${cwd}\imgui"
$flags = "-fdiagnostics-color=always", "-g"
$libs = "-lsfml-graphics", "-lsfml-window", "-lsfml-system", "-lopengl32", "-static-libgcc", "-static-libstdc++"

$objects = @()
$needs_relink = $false

foreach ($src in $sources) {
    $obj = $src -replace '\.cpp$', '.o'
    $objects += $obj
    
    $srcPath = Join-Path $cwd $src
    $objPath = Join-Path $cwd $obj

    $shouldCompile = $false
    if (-not (Test-Path $objPath)) {
        $shouldCompile = $true
    } else {
        $srcTime = (Get-Item $srcPath).LastWriteTime
        $objTime = (Get-Item $objPath).LastWriteTime
        if ($srcTime -ge $objTime) {
            $shouldCompile = $true
        }
    }

    if ($shouldCompile) {
        Write-Host "Compiling $src..." -ForegroundColor Cyan
        $cmd = "& `"$compiler`" -c `"$srcPath`" -o `"$objPath`" $flags $includes"
        Invoke-Expression $cmd
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error compiling $src" -ForegroundColor Red
            exit $LASTEXITCODE
        }
        $needs_relink = $true
    }
}

$exePath = Join-Path $cwd "game.exe"

if ($needs_relink -or (-not (Test-Path $exePath))) {
    Write-Host "Linking game.exe..." -ForegroundColor Cyan
    $objArgs = $objects -join " "
    $libArgs = $libs -join " "
    $flagArgs = $flags -join " "
    
    $cmd = "& `"$compiler`" $flagArgs $objArgs -o `"$exePath`" $libArgs"
    Invoke-Expression $cmd
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error linking game.exe" -ForegroundColor Red
        exit $LASTEXITCODE
    }
    Write-Host "Build finished successfully." -ForegroundColor Green
} else {
    Write-Host "Build is up to date." -ForegroundColor Green
}
