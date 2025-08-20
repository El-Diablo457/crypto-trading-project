@echo off
REM =====================================================
REM Fully Automated Crypto Trading Project Deployment
REM Windows-Friendly - Pre-filled environment variables
REM =====================================================

REM 1️⃣ Navigate to project folder
cd /d %~dp0

REM 2️⃣ Configure Git identity if not set
for /f "tokens=*" %%i in ('git config --global user.name') do set GIT_NAME=%%i
for /f "tokens=*" %%i in ('git config --global user.email') do set GIT_EMAIL=%%i

if "%GIT_NAME%"=="" (
    git config --global user.name "Louise Zamiel"
    echo Git global user.name set to Louise Zamiel
)
if "%GIT_EMAIL%"=="" (
    git config --global user.email "louisezamiel@gmail.com"
    echo Git global user.email set to louisezamiel@gmail.com
)

REM 3️⃣ Ensure main branch exists
git rev-parse --verify main >nul 2>&1
if errorlevel 1 (
    git checkout -b main
    echo Main branch created
) else (
    git checkout main
    echo Switched to main branch
)

REM 4️⃣ Update vercel.json with valid JSON
(
echo {
echo   "version": 2,
echo   "builds": [
echo     { "src": "package.json", "use": "@vercel/next" }
echo   ],
echo   "routes": [
echo     { "src": "/(.*)", "dest": "/" }
echo   ]
echo }
) > vercel.json
echo vercel.json has been updated successfully!
echo.

REM 5️⃣ Stage all changes
git add .

REM 6️⃣ Commit changes
set /p COMMIT_MSG=Enter commit message: 
git commit -m "%COMMIT_MSG%"

REM 7️⃣ Push to GitHub
git push -u origin main
echo.

REM 8️⃣ Set Vercel environment variables (pre-filled)
set SUPABASE_URL=your-supabase-url
set SUPABASE_ANON_KEY=your-anon-key
set MAYA_KEY=your-maya-secret-key

vercel env add NEXT_PUBLIC_SUPABASE_URL production %SUPABASE_URL%
vercel env add NEXT_PUBLIC_SUPABASE_ANON_KEY production %SUPABASE_ANON_KEY%
vercel env add MAYA_SECRET_KEY production %MAYA_KEY%
echo Vercel environment variables applied successfully.
echo.

REM 9️⃣ Deploy to Vercel production
vercel --prod

echo.
echo =====================================================
echo Deployment complete! Visit your Vercel URL
echo =====================================================
pause