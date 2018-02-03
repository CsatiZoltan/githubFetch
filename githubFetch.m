function filestr = githubFetch(user, repository, downloadType, version)
% GITHUBFETCH  Download file from GitHub.
%   
%   Inputs:
%       user: name of the user or the organization
%       repository: name of the repository
%       downloadType: 'branch' or 'release'
%       version: if downloadType is 'branch': branch name (default: 'master')
%                if downloadType is 'release': release version
%   Output:
%       filestr: path to the downloaded file
%
%   The downloaded file type is .zip.
%
%   Examples:
%       1) githubFetch('GLVis', 'glvis', 'branch', 'master');
%       2) githubFetch('matlab2tikz', 'matlab2tikz', 'branch', 'develop');
%       3) githubFetch('matlab2tikz', 'matlab2tikz', 'release', '1.1.0');

%   Zoltan Csati
%   03/02/2018



narginchk(4, 4);
website = 'https://github.com';
if strcmpi(downloadType, 'release')
    versionName = ['v', version];
else
    versionName = version;
end

% Check for download type
assert(any(strcmpi(downloadType, {'branch', 'release'})), ...
    'Type must be either ''branch'' or ''release''.');

% Check if the repository exists for the given user
try
    urlread(fullfile(website, user));
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlread:FileNotFound')
        error('User does not exist.');
    end
end

% Check if the requested branch or version exists
try
    urlread(fullfile(website, user, repository));
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlread:FileNotFound')
        error('Repository does not exist.');
    end
end

% Download the requested branch or release
githubLink = fullfile(website, user, repository, 'archive', [versionName, '.zip']);
downloadName = [repository, '-', version, '.zip'];
try
    fprintf('Download started ...\n');
    filestr = urlwrite(githubLink, downloadName);
    fprintf('Repository %s successfully downloaded.\n', repository);
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlwrite:FileNotFound')
        if strcmpi(downloadType, 'branch')
            error('Branch ''%s'' does not exist.', version);
        elseif strcmpi(downloadType, 'release')
            error('Release version %s does not exist.', version);
        end
    else
        ME.rethrow;
    end
end