#pragma warning (disable:4996)
#include <iostream>
#include <windows.h>
#include <tlhelp32.h>
#include <string>
using namespace std;

BOOL Run_as_System(LPCWSTR run) {
	//提权到Debug以获取进程句柄
	//https://blog.csdn.net/zuishikonghuan/article/details/47746451
	HANDLE hToken;
	LUID Luid;
	TOKEN_PRIVILEGES tp;
	OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken);
	LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &Luid);
	tp.PrivilegeCount = 1;
	tp.Privileges[0].Luid = Luid;
	tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
	AdjustTokenPrivileges(hToken, false, &tp, sizeof(tp), NULL, NULL);
	CloseHandle(hToken);

	//枚举进程获取lsass.exe的ID和winlogon.exe的ID，它们是少有的可以直接打开句柄的系统进程
	DWORD idL, idW;
	PROCESSENTRY32 pe;
	pe.dwSize = sizeof(PROCESSENTRY32);
	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (Process32First(hSnapshot, &pe)) {
		do {
			if (0 == wcscmp(pe.szExeFile, L"lsass.exe")) {
				idL = pe.th32ProcessID;
			}
			else if (0 == wcscmp(pe.szExeFile, L"winlogon.exe")) {
				idW = pe.th32ProcessID;
			}
		} while (Process32Next(hSnapshot, &pe));
	}
	CloseHandle(hSnapshot);

	//获取句柄，先试lsass再试winlogon
	HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, idL);
	if (!hProcess)hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, idW);
	HANDLE hTokenx;
	//获取令牌
	OpenProcessToken(hProcess, TOKEN_DUPLICATE, &hTokenx);
	//复制令牌
	DuplicateTokenEx(hTokenx, MAXIMUM_ALLOWED, NULL, SecurityIdentification, TokenPrimary, &hToken);
	CloseHandle(hProcess);
	CloseHandle(hTokenx);
	//启动信息
	STARTUPINFOW si = { 0 };
	PROCESS_INFORMATION pi;
	si.cb = sizeof(STARTUPINFOW);
	si.lpDesktop = (LPWSTR)L"winsta0\\default";//显示窗口
	//启动进程，不能用CreateProcessAsUser否则报错1314无特权
	BOOL ret = CreateProcessWithTokenW(hToken, LOGON_NETCREDENTIALS_ONLY, NULL, (LPWSTR)run, NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi);
	CloseHandle(hToken);

	return ret;
}

int wmain(int argc, wchar_t** argv) {
	if (argc != 2) {
		printf("usage: sysrun.exe path_to_exe");
		return 1;
	}

	Run_as_System(argv[1]);
}
