using System;
using JetBrains.Annotations;

namespace nadena.dev.ndmf
{
    /// <summary>
    ///     This attribute declares a pass or an extension context to depend on another context.
    ///     When an extension context depends on another, it will implicitly activate the other context whenever the
    ///     depending context is activated.
    /// </summary>
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true)]
    [PublicAPI]
    public sealed class DependsOnContext : Attribute
    {
        public Type ExtensionContext { get; }

        public DependsOnContext(Type extensionContext)
        {
            if (!typeof(IExtensionContext).IsAssignableFrom(extensionContext))
            {
                throw new ArgumentException(
                    $"{extensionContext.FullName} does not implement {nameof(IExtensionContext)}",
                    nameof(extensionContext));
            }
            
            ExtensionContext = extensionContext;
        }
    }
}