
#------------------------------------------------------------------------------#
# Version 1.1                                                                  #
#------------------------------------------------------------------------------#
# This is a testing script that I am using to only record git and exercise git #
#------------------------------------------------------------------------------#
use strict;
use Env;
use Getopt::Std;
use File::Find;
no warnings 'File::Find';

my @excludeDirs;
my %dirs;

my $pwd;
my $verbose;
my %gitDirs;

my @branches = `git branch`;
my $activeBranch = getActiveBranch(\@branches);
print "my active branch is ", $activeBranch,"\n";
checkStatus();

my $refRepository = findAllRepository("/home/jcheng/");
print @$refRepository;

#my @scanDirs = ("c:/perl_bin/");
#scanDirs(\@scanDirs);

sub checkStatus ()
{
   my @status = `git status -s`;
   chomp @status;
   my $lines = @status;
   if ($lines >= 1)
   {
      print @status;
   }
   else
   {
      print "Nothing to worry about, you can switch branch\n";
   }
}

sub getActiveBranch ()
{
   my ($ref_mybranches) = @_;  
   chomp @$ref_mybranches;

   foreach my $branch  (@$ref_mybranches)
   {
      $branch =~ s/\s//g;
      if ($branch =~ /\*(\w+)/)
      {
         $activeBranch = $1;
      }
   }
   return $activeBranch;
}

sub findAllRepository
{
   my ($dir) = @_;
   print ("Scanning through directory ", $dir);
   print "\n","-"x80,"\n";
   my (@repository) = `find $dir -name \"\.git\"`;
   return \@repository;
}

sub scanDirs
{
   my ($rDirs,$rExcludeDirs) = @_;
   searchForPath($rDirs, $rExcludeDirs);
   #return getDirs();
}

sub searchDir 
{ 
   my $dir  = $File::Find::dir;
   if ($dir =~ /\.git$/)
   {
      print $dir,"\n";
   }
}

sub searchForPath 
{
   my ($refDirectoryToSearch,$rExcludeDirs) = @_;
   find({wanted => \&searchDir, no_chdir => 1 }, @$refDirectoryToSearch); 
}

sub findFile 
{ 
   my $path = $File::Find::name;
   $pwd  =~ s/\/$//;
   $path =~ s/$pwd//;

   my $dir  = $File::Find::dir;
   $dir =~ s/$pwd//;
   if (-f and -t)
   {
      $path =~ s/.*\///;
   }
}

sub searchForMyPath 
{
   my ($refDirectoryToSearch,$p) = @_;
   $pwd = $p;
   find(\&searchMyDir, @$refDirectoryToSearch);    
}

sub searchMyDir 
{ 
   my $path = $File::Find::name;
   $path =~ s/$pwd//;

   my $dir  = $File::Find::dir;
   $dir =~ s/$pwd//;

   if (-f and -t)
   {
      if ($File::Find::name =~ /.*as$/)
      {
         $path =~ s/$dir//;
         $path =~ s/^\///;
         #push(@{$classFiles{$path}}, $dir);
         #push(@{$classPathes{$dir}}, $path);
      }

      if ($File::Find::name =~ /include.*as$/)
      {
         #push(@{$includeFiles{$path}}, $dir);
         #push(@{$includePathes{$dir}}, $path);
      }

      # only for as2
      # if ($File::Find::name =~ /as2proj/)
      #{
      #   push(@{$as2projFiles{$path}}, $dir);
      #}
   }
}


