function filestr = githubFetch(user, repository, downloadType, name)
% GITHUBFETCH  Download file from GitHub.
%   
%   Inputs:
%       user: name of the user or the organization
%       repository: name of the repository
%       downloadType: 'branch' or 'release'
%       name (optional):
%           if downloadType is 'branch': branch name (default: 'master')
%           if downloadType is 'release': release version (default: 'latest')
%   Output:
%       filestr: path to the downloaded file
%
%   The downloaded file type is .zip.
%
%   Examples:
%       1) githubFetch('GLVis', 'glvis', 'branch')
%       % same as githubFetch('GLVis', 'glvis', 'branch', 'master')
%       2) githubFetch('matlab2tikz', 'matlab2tikz', 'branch', 'develop')
%       3) githubFetch('matlab2tikz', 'matlab2tikz', 'release', '1.1.0')
%       4) githubFetch('matlab2tikz', 'matlab2tikz', 'release')
%       % same as githubFetch('matlab2tikz', 'matlab2tikz', 'release', 'latest')

%   Zoltan Csati
%   04/02/2018



narginchk(3, 4);
website = 'https://github.com';

% Check for download type
branchRequested = strcmpi(downloadType, 'branch');
releaseRequested = strcmpi(downloadType, 'release');
assert(branchRequested | releaseRequested, ...
    'Type must be either ''branch'' or ''release''.');

% Check if the user exists
try
    urlread(fullfile(website, user));
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlread:FileNotFound')
        error('User does not exist.');
    end
end

% Check if the repository exists for the given user
try
    urlread(fullfile(website, user, repository));
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlread:FileNotFound')
        error('Repository does not exist.');
    end
end

% Process branch or release versions
if nargin < 4 % no branch or release version provided
    if branchRequested
        name = 'master';
    elseif releaseRequested
        name = 'latest';
    end
end
if releaseRequested
    if strcmpi(name, 'latest') % extract the latest version number
        s = urlread(fullfile(website, user, repository, 'releases', 'latest'));
        % Search based on https://stackoverflow.com/a/23756210/4892892
        [startIndex, endIndex] = regexp(s, '(?<=<title>).*?(?=</title>)');
        releaseLine = s(startIndex:endIndex);
        % Extract the release number
        [startIndex, endIndex] = regexp(releaseLine, '([0-9](\.?))+');
        name = releaseLine(startIndex:endIndex);
        assert(~isempty(name), 'No release found. Try downloading a branch.');
    end
    versionName = ['v', name];
elseif branchRequested
    versionName = name;
end

% Download the requested branch or release
githubLink = fullfile(website, user, repository, 'archive', [versionName, '.zip']);
downloadName = [repository, '-', name, '.zip'];
try
    fprintf('Download started ...\n');
    filestr = urlwrite(githubLink, downloadName);
    fprintf('Repository %s successfully downloaded.\n', repository);
catch ME
    if strcmp(ME.identifier, 'MATLAB:urlwrite:FileNotFound')
        if branchRequested
            error('Branch ''%s'' does not exist.', name);
        elseif releaseRequested
            error('Release version %s does not exist.', name);
        end
    else
        rethrow(ME);
    end
end
