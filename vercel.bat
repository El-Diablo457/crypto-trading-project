@echo off
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
pause